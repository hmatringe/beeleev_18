ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do

      column do
        panel "Beeleevers" do

          para do
            res = pluralize(User.activation_pending.count, "user") +
            " waiting activation - " +
            link_to("See all", admin_users_path(scope: "activation_pending"))

            res.html_safe
          end

          para do
            res = pluralize(User.active.count, "active user") +
            " - " +
            link_to("See all", admin_users_path(scope: "active"))

            res.html_safe
          end

          para do
            res = pluralize(User.rejected.count, "rejected user") +
            " - " +
            link_to("See all", admin_users_path(scope: "rejected"))

            res.html_safe
          end

        end
      end

    end

    columns do

      column do
        panel "Connection requests" do
          para "TODO"
        end
      end

      column do
        panel "Connection propositions" do
          para "TODO"
        end
      end

      column do
        panel "Connection demands" do

          ConnectionDemand.aasm.states.each do |state|
            para do
              res = state.name.to_s.titleize +
                    " : " +
                    ConnectionDemand.send(state.name).count.to_s +
                    " - " +
                    link_to("See all", admin_connection_demands_path(scope: state.name))

              res.html_safe
            end
          end

        end
      end

    end

  end # content
end
