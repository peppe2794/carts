FROM weaveworksdemos/msd-java:jre-latest

WORKDIR /usr/src/app
COPY *.jar ./app.jar

RUN	chown -R user:weaveworksdemos ./app.jar

USER user

ENTRYPOINT ["/usr/local/bin/java.sh","-jar","./app.jar", "--port=80"]
