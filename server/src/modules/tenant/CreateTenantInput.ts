import { Length } from "class-validator";
import { Field, InputType } from "type-graphql";

@InputType()
export class CreateTenantInput {
  @Field({ nullable: true })
  id: String;
  
  @Field()
  @Length(1, 255)
  firstName: String;

  @Field()
  @Length(1, 255)
  lastName: String;
}
