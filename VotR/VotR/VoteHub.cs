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
    private static readonly ConcurrentDictionary<string, int> Options = new ConcurrentDictionary<string, int>();

    private static readonly ConcurrentDictionary<string, string> Votes = new ConcurrentDictionary<string, string>(); 

    public void Register()
    {
      foreach (var option in Options)
      {
        Clients.Caller.UpdateOption(option.Key, option.Value);
      }
    }

    public void Vote(string option)
    {
      CancelPreviousVote();
      RecordNewVote(option);
    }

    private void CancelPreviousVote()
    {
      string prevVote;
      if (Votes.TryGetValue(Context.ConnectionId, out prevVote))
      {
        var newValue = Options.AddOrUpdate(prevVote, x => 0, (x, prevValue) => prevValue - 1);
        Clients.All.UpdateOption(prevVote, newValue);
      }
    }

    private void RecordNewVote(string option)
    {
      var newValue = Options.AddOrUpdate(option, x => 1, (x, prevValue) => prevValue + 1);
      Clients.All.UpdateOption(option, newValue);
      Votes.AddOrUpdate(Context.ConnectionId, x => option, (x, y) => option);
    }
  }
}