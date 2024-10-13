# Use the amd64 platform for the base Go image
# Start with a base image for building the Go application
FROM --platform=linux/amd64 golang:1.22 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod file to the working directory
COPY go.mod ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the Go application for amd64 architecture
RUN GOARCH=amd64 GOOS=linux go build -o main .

#######################################
# Final stage - Distroless image for reduced size
# Use the amd64 platform for the distroless image
FROM --platform=linux/amd64 gcr.io/distroless/base:latest

# Copy the binary from the build stage to the final image
COPY --from=base /app/main .

# Copy the static files from the build stage to the final image
COPY --from=base /app/static ./static

# Expose the port on which the app will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]
