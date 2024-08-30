FROM 10.0.1.123:5000/debian:12-slim AS build
WORKDIR /app

# Separate layers here to avoid redoing dependencies on code change.
COPY *.sln .
COPY *.csproj .
RUN dotnet restore

# Now the code.
COPY . .
RUN dotnet publish -r linux-musl-x64 -c Release -o out

FROM 10.0.1.123:5000/debian:12-slim AS runtime 
WORKDIR /app
COPY --from=build /app/out .

ENTRYPOINT ["./docker_exporter"]
