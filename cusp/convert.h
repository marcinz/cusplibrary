/*
 *  Copyright 2008-2009 NVIDIA Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */


#pragma once

#include <string>
#include <stdexcept>

namespace cusp
{

    class format_conversion_exception : public std::exception
    {
        public:
            format_conversion_exception(const std::string _msg) : msg(_msg) {}
            ~format_conversion_exception() throw() {}
            const char* what() const throw() { return msg.c_str(); }

        private:
            std::string msg;
    };


    template <class DestinationType, class SourceType>
    void convert(DestinationType& dst, const SourceType& src);

} // end namespace cusp

#include <cusp/detail/convert.inl>
