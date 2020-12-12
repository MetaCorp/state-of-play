import { Field, InputType } from "type-graphql";

import { UpdateOwnerInput } from "../owner/UpdateOwnerInput";
import { UpdatePropertyInput } from "../property/UpdatePropertyInput";
import { UpdateRepresentativeInput } from "../representative/UpdateRepresentativeInput";
import { UpdateTenantInput } from "../tenant/UpdateTenantInput";


@InputType()
class UpdateStateOfPlayDecorationInput {
    @Field()
    type: String
    
    @Field()
    nature: String
    
    @Field()
    state: String
    
    @Field()
    comment: String
}

@InputType()
class UpdateStateOfPlayRoomInput {
    @Field()
    name: String

    @Field(() => [UpdateStateOfPlayDecorationInput])
    decorations: [UpdateStateOfPlayDecorationInput]
}

@InputType()
export class UpdateStateOfPlayInput {
    @Field()
    id: string;

    @Field(() => UpdatePropertyInput)
    property: UpdatePropertyInput;
    
    @Field(() => UpdateOwnerInput)
    owner: UpdateOwnerInput;
    
    @Field(() => UpdateRepresentativeInput)
    representative: UpdateRepresentativeInput;

    @Field(() => [UpdateTenantInput])
    tenants: [UpdateTenantInput]

    @Field(() => [UpdateStateOfPlayRoomInput])
    rooms: [UpdateStateOfPlayRoomInput]
}
