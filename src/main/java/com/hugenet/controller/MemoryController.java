package com.hugenet.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

@RestController
public class MemoryController {

    private static final Logger logger = LoggerFactory.getLogger(MemoryController.class);
    private final AtomicLong counter = new AtomicLong();

    // Each entry holds a label and a large byte array to simulate memory consumption
    private final Map<String, byte[]> memoryStore = new LinkedHashMap<>();

    // Default chunk size: 10 MB
    private static final int DEFAULT_CHUNK_SIZE_MB = 10;

    @GetMapping("/addmemoryusage")
    public String addMemoryUsage(@RequestParam(value = "sizeMB", defaultValue = "10") int sizeMB,
                                  @RequestParam(value = "count", defaultValue = "1") int count) {
        logger.info("Calling /addmemoryusage - adding {} chunk(s) of {} MB each", count, sizeMB);

        int bytesPerChunk = sizeMB * 1024 * 1024;
        List<String> addedKeys = new ArrayList<>();

        for (int i = 0; i < count; i++) {
            long id = counter.incrementAndGet();
            String key = "chunk-" + id;
            byte[] data = new byte[bytesPerChunk];
            // Fill with non-zero data so the JVM actually allocates the memory
            java.util.Arrays.fill(data, (byte) 0xAB);
            memoryStore.put(key, data);
            addedKeys.add(key);
            logger.info("Added memory chunk '{}' ({} MB)", key, sizeMB);
        }

        return String.format("Added %d chunk(s) of %d MB each. Keys: %s. Total chunks in store: %d",
                count, sizeMB, addedKeys, memoryStore.size());
    }

    @GetMapping("/reducememoryusage")
    public String reduceMemoryUsage(@RequestParam(value = "count", defaultValue = "1") int count) {
        logger.info("Calling /reducememoryusage - removing {} chunk(s)", count);

        if (memoryStore.isEmpty()) {
            logger.info("Memory store is already empty, nothing to remove");
            return "Memory store is already empty. Nothing to remove.";
        }

        int toRemove = Math.min(count, memoryStore.size());
        List<String> removedKeys = new ArrayList<>();

        // Remove the oldest entries first (insertion order via LinkedHashMap)
        var iterator = memoryStore.entrySet().iterator();
        for (int i = 0; i < toRemove && iterator.hasNext(); i++) {
            var entry = iterator.next();
            removedKeys.add(entry.getKey());
            iterator.remove();
        }

        logger.info("Removed {} chunk(s): {}", removedKeys.size(), removedKeys);
        return String.format("Removed %d chunk(s): %s. Remaining chunks in store: %d",
                removedKeys.size(), removedKeys, memoryStore.size());
    }

    @GetMapping("/reportmemoryuse")
    public Map<String, Object> reportMemoryUse() {
        logger.info("Calling /reportmemoryuse");

        // Calculate data structure memory usage
        long totalDataBytes = 0;
        List<Map<String, Object>> chunks = new ArrayList<>();

        for (Map.Entry<String, byte[]> entry : memoryStore.entrySet()) {
            long chunkBytes = entry.getValue().length;
            totalDataBytes += chunkBytes;
            chunks.add(Map.of(
                    "key", entry.getKey(),
                    "sizeMB", chunkBytes / (1024 * 1024)
            ));
        }

        // JVM-level memory info
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory();
        long totalMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = totalMemory - freeMemory;

        Map<String, Object> report = new LinkedHashMap<>();
        report.put("chunkCount", memoryStore.size());
        report.put("dataStoreSizeMB", totalDataBytes / (1024 * 1024));
        report.put("dataStoreSizeBytes", totalDataBytes);
        report.put("chunks", chunks);

        Map<String, Object> jvm = new LinkedHashMap<>();
        jvm.put("maxMemoryMB", maxMemory / (1024 * 1024));
        jvm.put("totalAllocatedMemoryMB", totalMemory / (1024 * 1024));
        jvm.put("usedMemoryMB", usedMemory / (1024 * 1024));
        jvm.put("freeMemoryMB", freeMemory / (1024 * 1024));
        report.put("jvmMemory", jvm);

        logger.info("Memory report: {} chunks, {} MB in store, {} MB used by JVM",
                memoryStore.size(), totalDataBytes / (1024 * 1024), usedMemory / (1024 * 1024));

        return report;
    }
}
