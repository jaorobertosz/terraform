FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install ansible wget unzip python3-pip -y && \
    pip3 install boto && \
    wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip && \
    mv  terraform_1.7.0_linux_amd64.zip /tmp/ && \
    unzip /tmp/terraform_1.7.0_linux_amd64.zip -d /usr/bin \