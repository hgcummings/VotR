﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="VotR.Default" %>

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
                vm.currentOption = ko.observable();

                var voteHub = $.connection.voteHub;

                vm.nominate = function() {
                    voteOrSubmit($('#nominate').val());
                };

                function OptionViewModel(name, votes) {
                    var ovm = this;

                    ovm.name = name;
                    ovm.votes = ko.observable(votes);

                    ovm.selected = ko.computed(function() {
                        return ovm.name === vm.currentOption();
                    });

                    ovm.vote = function() {
                        voteOrSubmit(ovm.name);
                    };
                }

                function voteOrSubmit(option) {
                    voteHub.server.vote(option);
                    vm.currentOption(option);
                }

                voteHub.client.updateOption = function (name, votes) {
                    var existing = ko.utils.arrayFirst(vm.options(), function(option) {
                        return option.name === name;
                    });
                    if (existing) {
                        existing.votes(votes);
                    } else {
                        var newOption = new OptionViewModel(name, votes);
                        vm.options.push(newOption);
                    }
                };

                voteHub.client.reset = function() {
                    vm.options.removeAll();
                };

                $.connection.hub.start(function() {
                    voteHub.server.register();
                    $("#submit").removeAttr("disabled");
                });
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
            <tr data-bind="click: vote, style: {backgroundColor: selected() ? 'yellow' : ''}">
                <td data-bind="text: name"></td>
                <td data-bind="text: votes"></td>
            </tr>
        </tbody>
    </table>
    <form data-bind="submit: nominate">
        <input id="nominate" name="nominate"/>
        <input id="submit" type="submit" value="Nominate!" disabled="disabled"/>
    </form>
</body>
</html>
