using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace HelloWorldFunc
{
    public static class HelloWorld
    {
        [FunctionName("HelloWorld")]
        public static IActionResult Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("HelloWorld function processed a request.");
            return new OkObjectResult("Hello, World! from Azure Functions 🚀");
        }
    }
}
