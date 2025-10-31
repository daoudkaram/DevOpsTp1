
FROM node:20-alpine

#SET WORKDING DIR
WORKDIR /usr/src/app

COPY broken-app/package*.json ./

RUN npm install --production

COPY broken-app/. .

RUN addgroup -S appgroup && adduser -S appuser -G appgroup && chown -R appuser:appgroup /usr/src/app

USER appuser
EXPOSE 3000
CMD ["node", "server.js"]
