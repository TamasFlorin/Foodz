import App from '@/app';
import IndexRoute from '@routes/index.route';
import UsersRoute from '@routes/users.route';
import { serverConfig } from '@configs/server.config';
import RestaurantsRoute from '@routes/restaurants.route';
import ReviewRoute from '@routes/review.route';

const app = new App([new IndexRoute(), new UsersRoute(), new RestaurantsRoute(), new ReviewRoute()]);
app.listen(serverConfig.port);
