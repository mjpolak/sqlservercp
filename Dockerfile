FROM mcr.microsoft.com/dotnet/core/runtime:3.1-bionic

RUN apt-get update && apt install curl unzip libunwind8 libicu60 libssl1.0 gnupg gnupg2 gnupg1 -y

# Instal mssql tools
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/msprod.list
ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=y
RUN apt-get update 
RUN apt-get install mssql-tools unixodbc-dev -y
ENV PATH="$PATH:/opt/mssql-tools/bin"

# Install sql package
RUN curl -L https://go.microsoft.com/fwlink/?linkid=2134311 -o sqlpackage.zip
RUN mkdir sqlpackage
RUN unzip sqlpackage.zip -d /sqlpackage
RUN chmod a+x /sqlpackage/sqlpackage
ENV PATH "$PATH:/sqlpackage"
COPY . /
CMD . /execute.sh
