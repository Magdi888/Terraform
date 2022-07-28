FROM node:12
COPY nodeapp /nodeapp
WORKDIR /nodeapp
RUN npm install
RUN export $(cat .env | xargs)
CMD ["node", "/nodeapp/app.js"]