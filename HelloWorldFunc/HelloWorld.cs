using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Net;

namespace HelloWorldFunc
{
    // The class and method are no longer static for the isolated model
    public class HelloWorld
    {
        private readonly ILogger<HelloWorld> _logger;

        public HelloWorld(ILogger<HelloWorld> logger)
        {
            _logger = logger;
        }

        [Function("HelloWorld")]
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req)
        {
            _logger.LogInformation("HelloWorld function processed a request.");
            
            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");
            response.WriteString("Hello, World! from Azure Functions 🚀");
            
            return response;
        }
    }
}