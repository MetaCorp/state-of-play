import { Field, InputType } from "type-graphql";
import { CreateStateOfPlayInput } from "./CreateStateOfPlayInput";

@InputType()
export class UpdateStateOfPlayInput {  
    @Field()
    stateOfPlayId: string;

    @Field()
    stateOfPlay: CreateStateOfPlayInput
}
