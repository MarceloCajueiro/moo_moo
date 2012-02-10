module MooMoo
  class Cookie < Base

    ##
    # Creates a cookie for a domain
    #
    # ==== Required
    #  * <tt>:username</tt> - username of the registrant
    #  * <tt>:password</tt> - password of the registrant
    #  * <tt>:domain</tt> - domain to set the cookie for
    register_service :set, :cookie

    ##
    # Deletes a cookie that was previously set
    #
    # ==== Required
    #  * <tt>:cookie</tt> - cookie to delete
    register_service :delete, :cookie

    ##
    # Updates a cookie to be valid for a different domain
    #
    # ==== Required
    #  * <tt>:old_domain</tt> - domain the cookie is currently set for
    #  * <tt>:new_domain</tt> - domain to set the cookie for
    #  * <tt>:cookie</tt> - cookie to update
    register_service :update, :cookie

    ##
    # Cleanly terminates the connection
    #
    register_service :quit_session, :session, :quit
  end
end