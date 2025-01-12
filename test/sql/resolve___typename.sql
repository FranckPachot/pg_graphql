begin;

    create table account(
        id int primary key,
        parent_id int references account(id)
    );


    insert into public.account(id, parent_id)
    values
        (1, 1);


    select jsonb_pretty(
        graphql.resolve($$
    {
      accountCollection {
        __typename
        pageInfo {
          __typename
        }
        edges {
          __typename
          node {
            __typename
            parent {
              __typename
            }
          }
        }
      }
    }
        $$)
    );

rollback;
