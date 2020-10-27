FROM nextcloud:20.0.0-apache
LABEL maintainer="Gavin Mogan <docker@gavinmogan.com>"


# Install all the plugins
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/notes \
 && curl -sL https://github.com/nextcloud/notes/releases/download/v4.0.0/notes.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/notes
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/contacts \
 && curl -sL https://github.com/nextcloud/contacts/releases/download/v3.4.1/contacts.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/contacts
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/twofactor_totp \
 && curl -sL https://github.com/nextcloud/twofactor_totp/releases/download/v5.0.0/twofactor_totp.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/twofactor_totp
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/calendar \
 && curl -sL https://github.com/nextcloud/calendar/releases/download/v2.1.2/calendar.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/calendar
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/tasks \
 && curl -sL https://github.com/nextcloud/tasks/releases/download/v0.13.5/tasks.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/tasks
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/ocsms \
 && curl -sL https://github.com/nextcloud/ocsms/releases/download/2.1.8/ocsms-2.1.8.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/ocsms
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/files_accesscontrol \
 && curl -sL https://github.com/nextcloud/files_accesscontrol/releases/download/v1.10.0/files_accesscontrol-1.10.0.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/files_accesscontrol
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/files_automatedtagging \
 && curl -sL https://github.com/nextcloud/files_automatedtagging/releases/download/v1.10.0/files_automatedtagging-1.10.0.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/files_automatedtagging
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/files_retention \
 && curl -sL https://github.com/nextcloud/files_retention/releases/download/v1.8.2/files_retention-1.8.2.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/files_retention
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/terms_of_service \
 && curl -sL https://github.com/nextcloud/terms_of_service/releases/download/v1.6.1/terms_of_service-1.6.1.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/terms_of_service
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/deck \
 && curl -sL https://github.com/nextcloud/deck/releases/download/v1.1.2/deck.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/deck
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/announcementcenter \
 && curl -sL https://github.com/nextcloud/announcementcenter/releases/download/v4.0.0/announcementcenter-4.0.0.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/announcementcenter
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/circles \
 && curl -sL https://github.com/nextcloud/circles/releases/download/v0.20.2/circles-0.20.2.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/circles
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/groupfolders \
 && curl -sL https://github.com/nextcloud/groupfolders/releases/download/v8.1.0/groupfolders-8.1.0.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/groupfolders
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/oidc_login \
 && curl -sL https://github.com/pulsejet/nextcloud-oidc-login/releases/download/v1.6.0/oidc_login.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/oidc_login
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/bruteforcesettings \
 && curl -sL https://github.com/nextcloud/bruteforcesettings/releases/download/v2.0.1/bruteforcesettings.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/bruteforcesettings
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/mail \
 && curl -sL https://github.com/nextcloud/mail/releases/download/v1.5.0/mail.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/mail
RUN set -o pipefail && mkdir -p /usr/src/nextcloud/apps/richdocuments \
 && curl -sL https://github.com/nextcloud/richdocuments/releases/download/v3.7.5/richdocuments.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/richdocuments

# once installed, apps dir should not be writable
RUN chown nobody: -R /usr/src/nextcloud/apps
RUN mkdir -p /usr/src/nextcloud/custom_apps && chown nobody: -R /usr/src/nextcloud/custom_apps
RUN mkdir -p /data && ln -s /data /usr/src/nextcloud/version.phpVOLUME ["/usr/src/nextcloud/data", "/usr/src/nextcloud/config"]
EXPOSE 80
