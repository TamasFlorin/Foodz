import config from 'config';
import { ServerConfig } from '@interfaces/server.config.interface';

export const serverConfig: ServerConfig = config.get('serverConfig');
