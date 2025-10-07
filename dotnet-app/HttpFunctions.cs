using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Net;
using System.Runtime.InteropServices;

namespace NetFrameworkApp
{
    public class HttpFunctions
    {
        private readonly ILogger _logger;

        public HttpFunctions(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<HttpFunctions>();
        }

        [Function("HttpTrigger1")]
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            var targetFramework = RuntimeInformation.FrameworkDescription; 
            response.WriteString($"Welcome to Azure Functions! RuntimeInformation.FrameworkDescription:{targetFramework}");

            return response;
        }
    }
}
