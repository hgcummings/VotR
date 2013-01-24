using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace VotR
{
  public class VoteHub : Hub
  {
    private static readonly Dictionary<string, int> OptionsInit = new Dictionary<string, int>
      {
        { "Red", 4},
        {"Green", 5},
        {"Blue", 98}
      };

    private static readonly ConcurrentDictionary<string, int> Options = new ConcurrentDictionary<string, int>(OptionsInit);

    public void Register()
    {
      foreach (var option in Options)
      {
        Clients.Caller.UpdateOption(option.Key, option.Value);
      }
    }

    public void Vote(string option)
    {
      var newValue = Options.AddOrUpdate(option, x => 1, (x, prevValue) => prevValue + 1);
      Clients.All.UpdateOption(option, newValue);
    }
  }
}