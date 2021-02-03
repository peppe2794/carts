FROM weaveworksdemos/msd-java:jre-latest

WORKDIR /usr/src/app
COPY *.jar ./app.jar

RUN	chown -R myuser:mygroup ./app.jar
USER myuser

ENTRYPOINT ["/usr/local/bin/java.sh","-Djava.security.egd=file:/dev/urandom","-jar","./app.jar", "--port=80"]
