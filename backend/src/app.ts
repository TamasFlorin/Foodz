import express from 'express';
import cookieParser from 'cookie-parser';
import morgan from 'morgan';
import logger, { stream } from '@utils/logger';
import AppRoute from '@interfaces/route.interface';
import errorMiddleware from '@middlewares/error.middleware';
import mongoose from 'mongoose';
import { dbConnection } from '@configs/mongo.config';

class App {
  private listener: express.Application;

  constructor(routes: AppRoute[]) {
    this.listener = express();

    this.connectDb();
    this.addMiddlewares();
    this.addRoutes(routes);
    this.addErrorHandler();
  }

  public listen(port: number) {
    this.listener.listen(port, () => {
      logger.info(`Application listening on: ${port}`);
    });
  }

  private addMiddlewares() {
    this.listener.use(morgan('dev', { stream: stream }));
    this.listener.use(express.json());
    this.listener.use(express.urlencoded({ extended: false }));
    this.listener.use(cookieParser());
  }

  private addRoutes(routes: AppRoute[]) {
    routes.forEach(route => {
      this.listener.use(route.path, route.router);
    });
  }

  private connectDb() {
    mongoose
      .connect(dbConnection.url, dbConnection.options)
      .then(() => {
        logger.info(`Connected to database ${dbConnection.url}`);
      })
      .catch(err => {
        logger.error(`Failed to connect to database ${dbConnection.url} with error ${err}`);
        process.exit(1);
      });
  }

  private addErrorHandler() {
    this.listener.use(errorMiddleware);
  }
}

export default App;
