function notify
    # TODO: Добавить подсчет дельты времени от запуска notify до уведомленния.
    # TODO: Сохранить имя процесса и вывести его в сообщении.
    # TODO: https://github.com/jorgebucaran/humantime.fish
    set -l job (jobs -l -g)
    or begin; echo "There are no jobs" >&2; return 1; end

    function _notify_job_$job --on-job-exit $job --inherit-variable job
        echo -e \a
        echo -e '\\x1b]99;i=1:d=0;Job completed\\x1b\\\\\x1b]99;i=1:d=1:p=body;Job #' $job ' completed\x1b\\'
        functions -e _notify_job_$job
    end
end
