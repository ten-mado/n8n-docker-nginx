# n8n-docker-nginx

## Usage
```shell
$ cp .env.example .env
$ vim .env # <- Rewrite variables
$ docker-compose up --build -d
```

then open http://localhost

## Backup And Restore
```shell
$ docker-compose exec postgres pg_dumpall \
--clean --username ${POSTGRES_USER} > backup.sql
```

restore DB from `backup.sql`

```shell
$ docker-compose down app
$ cat backup.sql | docker-compose exec -T postgres psql --username ${POSTGRES_USER}

$ docker-compose exec postgres bash # change password if algorithm has changed.
$ su postgres
$ psql
postgres=# \password ${POSTGRES_NON_ROOT_USER};
postgres=# \password ${POSTGRES_USER};

$ docker-compose down
$ docker-compose up -d # restart
```

## 備考(Japanese Only)
- `.n8n/config` 内の `encryptionKey` はDB暗号化のキーになります
  - これを見失うとDBの復元が出来ないので、環境変数として取り回すか、このキーを保管して下さい。
  - Ref: https://docs.n8n.io/hosting/environment-variables/configuration-methods/#encryption-key