FROM metabase/metabase:latest

EXPOSE 3000

ENTRYPOINT ["/app/run_metabase.sh"]