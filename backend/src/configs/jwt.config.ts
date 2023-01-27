import config from 'config';
import { JWTConfig } from '@interfaces/jwt.config.interface';

export const jwtConfig: JWTConfig = config.get('jwtConfig');
