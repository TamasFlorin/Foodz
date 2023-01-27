import AppRoute from '@interfaces/route.interface';
import { Router } from 'express';
import validationMiddleware from '@middlewares/validation.middleware';
import { CreateRestaurantDto, DeleteRestaurantDto, GetRestaurantDto, GetRestaurantsDto, UpdateRestaurantDto } from '@dtos/restaurant.dto';
import authMiddleware from '@middlewares/auth.middleware';
import roleMiddleware from '@middlewares/role.middleware';
import { UserRole } from '@interfaces/user.interface';
import RestaurantController from '@controllers/restaurant.controller';

export default class RestaurantsRoute implements AppRoute {
  public path = '/restaurants';
  public router = Router();

  private restaurantController = new RestaurantController();

  constructor() {
    this.router.post(
      '/create',
      validationMiddleware(CreateRestaurantDto, 'body'),
      authMiddleware,
      roleMiddleware([UserRole.Owner, UserRole.Admin]),
      this.restaurantController.create,
    );
    this.router.post('/get', validationMiddleware(GetRestaurantsDto, 'body'), authMiddleware, this.restaurantController.getAll);
    this.router.get('/get/:id', validationMiddleware(GetRestaurantDto, 'params'), authMiddleware, this.restaurantController.get);
    this.router.delete(
      '/delete/:id',
      validationMiddleware(DeleteRestaurantDto, 'params'),
      authMiddleware,
      roleMiddleware([UserRole.Admin]),
      this.restaurantController.delete,
    );
    this.router.put(
      '/update',
      validationMiddleware(UpdateRestaurantDto, 'body'),
      authMiddleware,
      roleMiddleware([UserRole.Admin]),
      this.restaurantController.update,
    );
  }
}
