using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace VotR
{
  public class VoteHub : Hub
  {
    private static readonly Dictionary<string, int> Options = new Dictionary<string, int>
      {
        { "Red", 4},
        {"Green", 5},
        {"Blue", 98}
      };

    public void Register()
    {
      foreach (var option in Options)
      {
        Clients.Caller.UpdateOption(option.Key, option.Value);
      }
    }
  }
}