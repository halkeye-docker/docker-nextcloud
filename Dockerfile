FROM nextcloud:18.0.3-apache
MAINTAINER Gavin Mogan <docker@gavinmogan.com>

# Install all the plugins
RUN mkdir -p /usr/src/nextcloud/apps/notes \
 && curl -sL https://github.com/nextcloud/notes/releases/download/3.2.0/notes.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/notes
RUN mkdir -p /usr/src/nextcloud/apps/contacts \
 && curl -sL https://github.com/nextcloud/contacts/releases/download/v3.2.0/contacts.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/contacts
RUN mkdir -p /usr/src/nextcloud/apps/twofactor_totp \
 && curl -sL https://github.com/nextcloud/twofactor_totp/releases/download/v4.1.3/twofactor_totp.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/twofactor_totp
RUN mkdir -p /usr/src/nextcloud/apps/calendar \
 && curl -sL https://github.com/nextcloud/calendar/releases/download/v2.0.3/calendar.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/calendar
RUN mkdir -p /usr/src/nextcloud/apps/tasks \
 && curl -sL https://github.com/nextcloud/tasks/releases/download/v0.12.1/tasks.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/tasks
RUN mkdir -p /usr/src/nextcloud/apps/ocsms \
 && curl -sL https://github.com/nextcloud/ocsms/releases/download/2.1.7/ocsms-2.1.7.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/ocsms
RUN mkdir -p /usr/src/nextcloud/apps/files_accesscontrol \
 && curl -sL https://github.com/nextcloud/files_accesscontrol/releases/download/v1.8.1/files_accesscontrol-1.8.1.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/files_accesscontrol
RUN mkdir -p /usr/src/nextcloud/apps/files_automatedtagging \
 && curl -sL https://github.com/nextcloud/files_automatedtagging/releases/download/v1.8.2/files_automatedtagging-1.8.2.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/files_automatedtagging
RUN mkdir -p /usr/src/nextcloud/apps/files_retention \
 && curl -sL https://github.com/nextcloud/files_retention/releases/download/v1.7.0/files_retention-1.7.0.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/files_retention
RUN mkdir -p /usr/src/nextcloud/apps/terms_of_service \
 && curl -sL https://github.com/nextcloud/terms_of_service/releases/download/v1.4.0/terms_of_service-1.4.0.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/terms_of_service
RUN mkdir -p /usr/src/nextcloud/apps/deck \
 && curl -sL https://github.com/nextcloud/deck/releases/download/v0.8.2/deck.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/deck
RUN mkdir -p /usr/src/nextcloud/apps/announcementcenter \
 && curl -sL https://github.com/nextcloud/announcementcenter/releases/download/v3.8.0/announcementcenter-3.8.0.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/announcementcenter
RUN mkdir -p /usr/src/nextcloud/apps/circles \
 && curl -sL https://github.com/nextcloud/circles/releases/download/v0.17.13/circles-0.17.13.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/circles
RUN mkdir -p /usr/src/nextcloud/apps/dashboard \
 && curl -sL https://github.com/nextcloud/dashboard/releases/download/v6.0.0/dashboard-6.0.0.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/dashboard
RUN mkdir -p /usr/src/nextcloud/apps/groupfolders \
 && curl -sL https://github.com/nextcloud/groupfolders/releases/download/v6.0.5/groupfolders.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/groupfolders
RUN mkdir -p /usr/src/nextcloud/apps/user_saml \
 && curl -sL https://github.com/nextcloud/user_saml/releases/download/v3.0.1/user_saml-3.0.1.tar.gz | tar xz --strip-components=1 -C /usr/src/nextcloud/apps/user_saml

# once installed, apps dir should not be writable
RUN chown nobody: -R /usr/src/nextcloud/apps
VOLUME ["/usr/src/nextcloud/data", "/usr/src/nextcloud/config"]
EXPOSE 80
