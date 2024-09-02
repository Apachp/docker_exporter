FROM mcr.microsoft.com/dotnet/sdk:6.0-bookworm-slim AS build
WORKDIR /app

# Separate layers here to avoid redoing dependencies on code change.
COPY *.sln .
COPY *.csproj .
RUN dotnet restore

# Now the code.
COPY . .
RUN dotnet publish --self-contained -r debian.12-x64 -c Release -o out

FROM mcr.microsoft.com/dotnet/runtime:6.0-bookworm-slim AS runtime 
WORKDIR /app
COPY --from=build /app/out .

ENTRYPOINT ["./docker_exporter"]
