<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Chart.aspx.cs" Inherits="VotR.Chart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>VotR</title>
    <style>
        body {
            font-family: Helvetica, sans-serif;
        }
    </style>
    <script type="text/javascript" src="<%: ResolveClientUrl("~/scripts/jquery-1.6.4.min.js") %>"></script>
    <script type="text/javascript" src="<%: ResolveClientUrl("~/scripts/jquery.signalR-1.0.0-rc2.min.js") %>"></script>
    <script type="text/javascript" src="<%: ResolveClientUrl("~/signalr/hubs") %>"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart"] });

        var initialise = function () {
            var voteHub = $.connection.voteHub;
            $.connection.hub.start(voteHub.server.register);

            $('form#nominate').submit(function (event) {
                voteHub.server.vote(this['nomination'].value);
                event.preventDefault();
            });

            var chartView = new function () {
                var view = this;

                var chart = new google.visualization.PieChart(document.getElementById('chart_div'));

                var dataTable = new google.visualization.DataTable();
                dataTable.addColumn('string');
                dataTable.addColumn('number');

                var redraw = function () {
                    var options = {
                        chartArea: { width: '100%', height: '100%' },
                        height: 600
                    };

                    chart.draw(dataTable, options);
                };

                this.updateOption = function (name, votes) {
                    var existingRow = dataTable.getFilteredRows([{ column: 0, value: name }]);

                    if (existingRow.length) {
                        dataTable.setCell(existingRow[0], 1, votes);
                    } else {
                        dataTable.addRow([name, votes]);
                    }

                    redraw();
                };

                google.visualization.events.addListener(chart, 'select', function () {
                    var selection = dataTable.getValue(chart.getSelection()[0].row, 0);
                    view.model.select(selection);
                });
            };

            var chartViewModel = new function () {
                chartView.model = this;
                voteHub.client.updateOption = chartView.updateOption;
            };
        };

        $(function () {
            google.setOnLoadCallback(initialise);
        });
    </script>
</head>
<body>
    <h1>SignalR Demo @ SoftCon</h1>
    <div id="chart_div"></div>
    <h2><a href="http://bit.ly/10dS2Fo">http://bit.ly/10dS2Fo</a></h2>
    <h3><a href="http://softcon.azurewebsites.net">http://softcon.azurewebsites.net</a></h3>
</body>
</html>
