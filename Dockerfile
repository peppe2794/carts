FROM java:openjdk-8-alpine

WORKDIR /usr/src/app
COPY /var/lib/jenkins/workspace/carts@2/target/carts.jar ./app.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/urandom","-jar","./app.jar", "--port=80"]
