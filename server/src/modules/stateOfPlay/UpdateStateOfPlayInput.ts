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
class UpdateStateOfPlayElectricityInput {
  @Field()
  type: String
  
  @Field()
  quantity: Number
  
  @Field()
  state: String
  
  @Field()
  comment: String
}

@InputType()
class UpdateStateOfPlayEquipmentInput {
  @Field()
  type: String
  
  @Field()
  quantity: Number

  @Field()
  brandOrObject: String
  
  @Field()
  state: String
  
  @Field()
  comment: String
}

@InputType()
class UpdateStateOfPlayMeterInput {
  @Field()
  type: String
  
  @Field()
  location: String

  @Field()
  index: Number
}

@InputType()
class UpdateStateOfPlayRoomInput {
    @Field()
    name: String

    @Field(() => [UpdateStateOfPlayDecorationInput])
    decorations: [UpdateStateOfPlayDecorationInput]

    @Field(() => [UpdateStateOfPlayElectricityInput])
    electricities: [UpdateStateOfPlayElectricityInput]
  
    @Field(() => [UpdateStateOfPlayEquipmentInput])
    equipments: [UpdateStateOfPlayEquipmentInput]
}

@InputType()
export class UpdateStateOfPlayInput {
    @Field()
    id: string;

    @Field(() => UpdatePropertyInput)
    property: UpdatePropertyInput
    
    @Field(() => UpdateOwnerInput)
    owner: UpdateOwnerInput
    
    @Field(() => UpdateRepresentativeInput)
    representative: UpdateRepresentativeInput

    @Field(() => [UpdateTenantInput])
    tenants: [UpdateTenantInput]

    @Field(() => [UpdateStateOfPlayRoomInput])
    rooms: [UpdateStateOfPlayRoomInput]
  
    @Field(() => [UpdateStateOfPlayMeterInput])
    meters: [UpdateStateOfPlayMeterInput]
}
