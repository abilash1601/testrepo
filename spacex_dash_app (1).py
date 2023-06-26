import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output
import plotly.graph_objects as go
import pandas as pd

app = dash.Dash(__name__)
server = app.server

# Assuming you have a DataFrame named spacex_df
# and a list of launch sites named launch_sites
spacex_df = pd.read_csv("spacex_launch_dash.csv")
launch_sites = spacex_df['Launch Site'].unique()

app.layout = html.Div([
    html.H1("SpaceX Launch Success Analysis"),
    html.Label("Select a launch site:"),
    dcc.Dropdown(
        id='site-dropdown',
        options=[
            {'label': site, 'value': site} for site in launch_sites
            ],
        value='ALL'
    ),
    dcc.Graph(id='success-pie-chart')
])

@app.callback(
    Output(component_id='success-pie-chart', component_property='figure'),
    Input(component_id='site-dropdown', component_property='value')
)
def update_pie_chart(selected_site):
    if selected_site == 'ALL':
        # Calculate total success launches for all sites
        total_success_count = spacex_df[spacex_df['class'] == 1].shape[0]
        total_failed_count = spacex_df[spacex_df['class'] == 0].shape[0]

        # Create labels and values for the pie chart
        labels = ['Success', 'Failed']
        values = [total_success_count, total_failed_count]

        # Create the pie chart
        fig = go.Figure(data=[go.Pie(labels=labels, values=values)])

        # Set chart layout
        fig.update_layout(title_text="Total Launch Success/Failure for All Sites")

    else:
        # Filter the DataFrame based on the selected site
        filtered_df = spacex_df[spacex_df['launch_site'] == selected_site]

        # Count the number of successful and failed launches for the selected site
        success_count = filtered_df[filtered_df['class'] == 1].shape[0]
        failed_count = filtered_df[filtered_df['class'] == 0].shape[0]

        # Create labels and values for the pie chart
        labels = ['Success', 'Failed']
        values = [success_count, failed_count]

        # Create the pie chart
        fig = go.Figure(data=[go.Pie(labels=labels, values=values)])

        # Set chart layout
        fig.update_layout(title_text=f"Launch Success/Failure for Site: {selected_site}")

    return fig

if __name__ == '__main__':
    app.run_server(debug=True)
