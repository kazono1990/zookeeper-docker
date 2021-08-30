# zookeeper-docker
Docker image for TLS enabled Apache ZooKeeper.

## Start ZooKeeper Cluster
```bash
# 3 Nodes
$ docker-compose -f docker-compose_3nodes.yaml up -d

# 5 Nodes
$ docker-compose -f docker-compose_5nodes.yaml up -d
```

## Stop ZooKeeper Cluster
```bash
# 3 Nodes
$ docker-compose -f docker-compose_3nodes.yaml down

# 5 Nodes
$ docker-compose -f docker-compose_5nodes.yaml down
```
