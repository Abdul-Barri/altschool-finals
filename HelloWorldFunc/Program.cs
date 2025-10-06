using Microsoft.Extensions.Hosting;

// This Program.cs file is the new entry point for .NET 8 isolated function apps.
var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .Build();

host.Run();