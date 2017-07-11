# Docker image for Grafana

This project attempts to build a Docker image that runs:

- Carbon (for Metrics collection for Graphite)
- Graphite (acts as a datasource for Grafana)
- Grafana (Metrics visualization)

## Ports

- Carbon uses port '2003' to gather metrics
- Graphite web UI is configured to run on port '80'
- Grafana web UI is configured to run on port '3000'

# How to build and run

To build the project, make sure you have Docker installed and the Docker daemon
running. Then run:

```
./helper-build.sh
```

This will build the docker image named 'grafana'

To run the project, execute:

```
./helper-run.sh
```

Note that this script will attempt to bind to port 80, 2003, and 3000 on your
machine.

# Configure Graphite as a datasource to Grafana

Log into Grafana: http://localhost:3000

The username and password are: admin

Follow the gif below to see how to add the Graphite instance as a datasource
![Alt Text](https://github.com/thescouser89/grafana-docker/raw/master/gifs/datasource.gif)


# Test the metrics

To send some dummy metrics to Graphite so that we can visualize it on Grafana,
run:

```
./helper-metric-test.sh
```

Then on Grafana:
![Alt Text](https://github.com/thescouser89/grafana-docker/raw/master/gifs/metrics.gif)


# TODO

- [ ] Add ability to specify a path where to store the graphite/grafana data
- [ ] Make sure path for graphite/grafana data has right permissions
