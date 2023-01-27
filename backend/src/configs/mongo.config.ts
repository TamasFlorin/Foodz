import config from 'config';
import { DatabaseConfig } from '@interfaces/db.config.interface';
import mongoose from 'mongoose';

export interface DatabaseConnection {
  url: string;
  options: mongoose.ConnectOptions;
}

const { host, port, database }: DatabaseConfig = config.get('dbConfig');

export const dbConnection: DatabaseConnection = {
  url: `mongodb://${host}:${port}/${database}`,
  options: {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useFindAndModify: false,
    useCreateIndex: true,
  },
};
