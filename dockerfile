FROM alpine:3.7

### 2. Get Java via the package manager
RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash \
&& apk add --no-cache --virtual=build-dependencies unzip \
&& apk add --no-cache curl \
&& apk add --no-cache openjdk8-jre

### 3. Get Python, PIP
RUN apk add --no-cache python3 \
&& python3 -m ensurepip \
&& pip3 install --upgrade pip setuptools \
&& rm -r /usr/lib/python*/ensurepip && \
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
rm -r /root/.cache

ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"

### Set the working directory
WORKDIR /app

### Install Git
RUN apk add --no-cache git

### Clone the jadx repository and build it
RUN git clone https://github.com/skylot/jadx.git \
&& cd jadx \
&& ./gradlew dist

### Add your Python scripts
ADD apkAnalyzer.py /app
ADD apkDownloader.py /app

### Add the requirements.txt file
ADD requirements.txt /app

### Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# After adding your Python scripts
ADD run_scripts.sh /app
RUN chmod +x /app/run_scripts.sh

# Use CMD to execute the shell script
CMD ["/app/run_scripts.sh"]