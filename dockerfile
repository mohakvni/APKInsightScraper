FROM alpine:latest

# Install necessary system packages including Python and OpenJDK
RUN apk update && apk upgrade && \
    apk add --no-cache bash curl vim git nss openjdk11 python3 python3-dev && \
    apk add --no-cache build-base linux-headers cmake  # Add this line
    # Create a Python virtual environment
RUN python3 -m venv /app/venv

# Set JAVA_HOME environment variable for Java 11
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk"

# Activate the virtual environment for subsequent commands
ENV PATH="/app/venv/bin:$PATH"

# Set the working directory
WORKDIR /app

# Upgrade pip and setuptools within the virtual environment
RUN pip install --upgrade pip setuptools

# Add requirements.txt before installing dependencies
ADD requirements.txt /app

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Clone the jadx repository and build it
RUN git clone https://github.com/skylot/jadx.git && \
    cd jadx && \
    ./gradlew dist

# Add your Python scripts
ADD filtered_result.json /app
ADD apkAnalyzer.py /app
ADD apkDownload.py /app
ADD run_scripts.sh /app
RUN chmod +x /app/run_scripts.sh
RUN chmod a+wx /app/apkDownload.py
RUN chmod a+wx /app/apkAnalyzer.py
RUN chmod a+wx /app/delete.py