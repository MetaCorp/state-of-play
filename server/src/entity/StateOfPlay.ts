import { Entity, PrimaryGeneratedColumn, BaseEntity, ManyToOne } from "typeorm";
import { ObjectType, Field, ID } from "type-graphql";

import { User } from "./User";
import { Property } from "./Property";
import { Owner } from "./Owner";
import { Representative } from "./Representative";

@ObjectType()
@Entity()
export class StateOfPlay extends BaseEntity {
  @Field(() => ID)
  @PrimaryGeneratedColumn()
  id: number;

  @Field(() => Owner)
  @ManyToOne(() => Owner, owner => owner.stateOfPlays)
  owner: Owner;
  
  @Field(() => Representative)
  @ManyToOne(() => Representative, representative => representative.stateOfPlays)
  representative: Representative;

  @Field(() => User)
  @ManyToOne(() => User, user => user.stateOfPlays)
  user: User;

  @Field(() => Property)
  @ManyToOne(() => Property, property => property.stateOfPlays, { cascade: true })
  property: Property;
}
