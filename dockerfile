FROM node:12
COPY nodeapp /nodeapp
COPY env.sh /env.sh
WORKDIR /nodeapp
RUN npm install
CMD ["/bin/bash","-c","source /env.sh && node /nodeapp/app.js"]