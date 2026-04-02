package com.hugenet.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.atomic.AtomicLong;

@RestController
public class DemoWorldController {
    Logger logger = LoggerFactory.getLogger(DemoWorldController.class);

    private static final String demoWorldTemplate = "Hello from DemoWorld, %s!";
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private final AtomicLong counter = new AtomicLong();

    @GetMapping("/demoworld")
    public DemoWorld demoworld(@RequestParam(value = "name", defaultValue = "World") String name) {
        logger.info("Calling /demoworld");
        String currentTimestamp = LocalDateTime.now().format(formatter);
        return new DemoWorld(counter.incrementAndGet(), String.format(demoWorldTemplate, name), "success", currentTimestamp);
    }
}



