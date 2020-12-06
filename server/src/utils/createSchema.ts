import { buildSchema } from "type-graphql";
import { AuthorBookResolver } from "../modules/author-book/AuthorBookResolver";
import { ChangePasswordResolver } from "../modules/user/ChangePassword";
import { ConfirmUserResolver } from "../modules/user/ConfirmUser";
import {
  CreateProductResolver,
  CreateUserResolver
} from "../modules/user/CreateUser";
import { ForgotPasswordResolver } from "../modules/user/ForgotPassword";
import { LoginResolver } from "../modules/user/Login";
import { LogoutResolver } from "../modules/user/Logout";
import { MeResolver } from "../modules/user/Me";
import { ProfilePictureResolver } from "../modules/user/ProfilePicture";
import { RegisterResolver } from "../modules/user/Register";

import { UserResolver } from "../modules/user/UserResolver";
import { PropertyResolver } from "../modules/property/PropertyResolver";
import { StateOfPlayResolver } from "../modules/stateOfPlay/StateOfPlayResolver";

export const createSchema = () =>
  buildSchema({
    resolvers: [
      ChangePasswordResolver,
      ConfirmUserResolver,
      ForgotPasswordResolver,
      LoginResolver,
      LogoutResolver,
      MeResolver,
      RegisterResolver,
      CreateUserResolver,
      CreateProductResolver,
      ProfilePictureResolver,
      AuthorBookResolver,

      UserResolver,
      PropertyResolver,
      StateOfPlayResolver
    ],
    // authChecker: ({ context: { req: any } }) => {
    //   return !!req.session.userId;
    // }
  });