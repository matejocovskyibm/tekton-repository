FROM python:3.9.1-slim

RUN apt-get update

RUN apt-get install -y build-essential curl

RUN pip install ansible fabric-sdk-py

RUN ansible-galaxy collection install ibm.blockchain_platform

RUN curl -sSL https://bit.ly/2ysbOFE | bash -s -- -s -d