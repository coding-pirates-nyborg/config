FROM mcr.microsoft.com/powershell AS RUNTIME 

WORKDIR /config

COPY . .

RUN chmod -R +x /config/*.ps1

CMD ["/usr/bin/pwsh","/config/setup_env.ps1"]