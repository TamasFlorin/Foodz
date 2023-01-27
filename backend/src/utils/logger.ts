import winston from 'winston';
import fs from 'fs';

const logDir = 'logs';

if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir);
}

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(winston.format.timestamp(), winston.format.simple()),
  defaultMeta: { service: 'foodz_backend' },
  transports: [
    new winston.transports.File({ filename: `${logDir}/error.log`, level: 'error' }),
    new winston.transports.File({ filename: `${logDir}/combined.log` }),
    new winston.transports.Console({
      format: winston.format.simple(),
    }),
  ],
});

export const stream = {
  write: (message: string) => {
    logger.info(message.trim());
  },
};

export default logger;
