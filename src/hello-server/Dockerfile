FROM --platform=linux/amd64 node:20-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install
# RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD [ "node", "index.js" ]