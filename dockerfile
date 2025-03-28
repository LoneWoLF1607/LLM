# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Install dependencies and required tools
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    gnupg2 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome stable
RUN wget -q -O google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver (Linux version for version 134.0.6998.165)
RUN wget -q https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chromedriver-linux64.zip \
    && unzip chromedriver-linux64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm chromedriver-linux64.zip

# Set environment variables for Chrome and ChromeDriver
ENV CHROME_BIN="/usr/bin/google-chrome-stable"
ENV CHROMEDRIVER_PATH="/usr/local/bin/chromedriver"

# Set working directory to /opt/render/project
WORKDIR /opt/render/project

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into /opt/render/project
COPY . .

# Expose port 8000 (or whichever port your app uses)
EXPOSE 8000

# Command to run the FastAPI app (assuming your app is defined in hack.py with an app object)
CMD ["uvicorn", "hack:app", "--host", "0.0.0.0", "--port", "8000"]
