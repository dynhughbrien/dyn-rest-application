#
# Run the Build and Deployoment
#

FROM amazoncorretto:21.0.1

WORKDIR /app

COPY ./target/rest-application-1.0.5.jar /app/rest-application-1.0.5.jar

EXPOSE 8000
#CMD ["/bin/sh"]
CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "/app/rest-application-1.0.5.jar" ]
