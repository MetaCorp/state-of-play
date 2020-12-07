import { Field, InputType } from "type-graphql";

@InputType()
export class StateOfPlaysFilterInput {
  @Field()
  search: string;
}
