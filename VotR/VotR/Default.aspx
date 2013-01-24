<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="VotR.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VotR</title>
    <script type="text/javascript" src="<%: ResolveClientUrl("~/scripts/jquery-1.6.4.min.js") %>"></script>
    <script type="text/javascript" src="<%: ResolveClientUrl("~/scripts/jquery.signalR-1.0.0-rc2.min.js") %>"></script>
    <script type="text/javascript" src="<%: ResolveClientUrl("~/scripts/knockout-2.2.1.js") %>"></script>
    <script type="text/javascript" src="<%: ResolveClientUrl("~/signalr/hubs") %>"></script>
    <script type="text/javascript">
        $(function() {
            function ViewModel() {
                var vm = this;

                vm.options = ko.observableArray();

                var voteHub = $.connection.voteHub;

                voteHub.client.updateOption = function(name, votes) {
                    vm.options.push({ name: name, votes: votes });
                };

                $.connection.hub.start(voteHub.server.register);
            }

            ko.applyBindings(new ViewModel());
        });
    </script>
</head>
<body>
    <h1>VotR</h1>
    <table>
        <thead>
            <tr>
                <th>Option</th>
                <th>Votes</th>                
            </tr>
        </thead>
        <tbody data-bind="foreach: options">
            <tr>
                <td data-bind="text: name"></td>
                <td data-bind="text: votes"></td>
            </tr>
        </tbody>
    </table>
</body>
</html>
